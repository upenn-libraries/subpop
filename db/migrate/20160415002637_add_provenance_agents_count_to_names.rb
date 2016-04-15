class AddProvenanceAgentsCountToNames < ActiveRecord::Migration
  def change
    add_column :names, :provenance_agents_count, :integer, default: 0

    reversible do |dir|
      dir.up { data }
    end
  end

  def data
    Name.all.each do |name|
      if name.provenance_agents.count > 0
        puts "Updating provenance_agents_count for #{name} to #{name.provenance_agents.count}"
        Name.reset_counters(name.id, :provenance_agents)
      end
    end
  end
end