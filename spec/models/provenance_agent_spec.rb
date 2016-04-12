require 'rails_helper'

RSpec.describe ProvenanceAgent, type: :model do
  context 'factory' do
    it 'creates a ProvenanceAgent' do
      expect(create(:provenance_agent)).to be_a(ProvenanceAgent)
    end
  end

  context 'initialization' do
    it 'creates a ProvenanceAgent' do
      expect(ProvenanceAgent.new).to be_a(ProvenanceAgent)
    end
  end

  context 'validations:' do
    it 'is valid' do
      expect(build(:provenance_agent)).to be_valid
    end

    it 'is invalid without a role' do
      expect(build(:provenance_agent, role: nil)).not_to be_valid
    end

    it 'is invalid without an evidence' do
      expect(build(:provenance_agent, evidence: nil)).not_to be_valid
    end

    it 'is invalid without a name' do
      expect(build(:provenance_agent, name: nil)).not_to be_valid
    end
  end
end
