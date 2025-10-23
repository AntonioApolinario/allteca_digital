class MaterialPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      if user
        # Usuários autenticados veem materiais publicados + seus próprios
        scope.where(status: "publicado").or(scope.where(user: user))
      else
        # Usuários não autenticados veem apenas materiais publicados
        scope.where(status: "publicado")
      end
    end
  end

  def show?
    record.publicado? || (user && (record.user == user || user_admin?))
  end

  def create?
    user.present?
  end

  def update?
    user && (record.user == user || user_admin?)
  end

  def destroy?
    user && (record.user == user || user_admin?)
  end

  private

  def user_admin?
    # Adicione lógica de admin se necessário
    false
  end
end
