class AddSslCertOp < PendingAppOp

  field :fqdn, type: String
  field :ssl_certificate, type: String
  field :private_key, type: String
  field :pass_phrase, type: Array

  field :group_instance_id, type: String
  field :gear_id, type: String

  def execute(skip_node_ops=false)
    result_io = ResultIO.new
    unless skip_node_ops
      gear = get_gear()
      result_io = gear.add_ssl_cert(ssl_certificate, private_key, fqdn, pass_phrase)
    end
    a = pending_app_op_group.application.aliases.find_by(fqdn: fqdn)
    a.has_private_ssl_certificate = true
    a.certificate_added_at = Time.now
    pending_app_op_group.application.save
    result_io
  end

  def rollback(skip_node_ops=false)
    result_io = ResultIO.new
    unless skip_node_ops
      gear = get_gear()
      result_io = gear.remove_ssl_cert(fqdn)
    end
    begin
      a = pending_app_op_group.application.aliases.find_by(fqdn: fqdn)
      a.has_private_ssl_certificate = false
      a.certificate_added_at = nil
      pending_app_op_group.application.save
    rescue Mongoid::Errors::DocumentNotFound
      # ignore if alias is not found
    end
    result_io
  end

end
