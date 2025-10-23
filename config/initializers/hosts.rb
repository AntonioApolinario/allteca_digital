# Permitir todos os hosts em desenvolvimento para testes
if Rails.env.development? || Rails.env.test?
  Rails.application.config.hosts.clear
end
