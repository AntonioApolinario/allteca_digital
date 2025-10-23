class UpdateMaterialStatusToPortuguese < ActiveRecord::Migration[7.2]
  def up
    # Atualizar os status existentes para português
    Material.where(status: 'draft').update_all(status: 'rascunho')
    Material.where(status: 'published').update_all(status: 'publicado') 
    Material.where(status: 'archived').update_all(status: 'arquivado')
    
    # Alterar a constraint do banco se existir
    change_column :materials, :status, :string, default: 'rascunho'
  end
  
  def down
    # Reverter para inglês se necessário
    Material.where(status: 'rascunho').update_all(status: 'draft')
    Material.where(status: 'publicado').update_all(status: 'published')
    Material.where(status: 'arquivado').update_all(status: 'archived')
    
    change_column :materials, :status, :string, default: 'draft'
  end
end
