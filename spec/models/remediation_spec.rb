require 'rails_helper'

RSpec.describe Remediation, type: :model do
   let(:subject) {  create(:remediation) }
   context 'factory' do
     it 'creates a Remediation' do
       expect(create :remediation).to be_a Remediation
     end
   end

   context 'initialize' do
     it 'creates a Remediation' do
       expect(Remediation.new).to be_a Remediation
     end
   end
end
