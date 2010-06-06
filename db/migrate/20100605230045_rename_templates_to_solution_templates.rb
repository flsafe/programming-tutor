class RenameTemplatesToSolutionTemplates < ActiveRecord::Migration
  def self.up
    rename_table :templates, :solution_templates
  end

  def self.down
    rename_table :solution_templates, :templates
  end
end
