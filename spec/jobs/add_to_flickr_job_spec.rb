require 'rails_helper'

RSpec.describe AddToFlickrJob, type: :job do

  let(:evidence) { create(:evidence) }
  let(:user)     { create :user }
  subject(:job)  { described_class.perform_later evidence }

  it 'enquues the job' do
    ActiveJob::Base.queue_adapter = :test
    expect {
      AddToFlickrJob.perform_later evidence, user.id
    }.to have_enqueued_job(AddToFlickrJob).with evidence, user.id
  end

  it 'executes publish_new' do
    expect(evidence).to receive(:publish_new)
    described_class.perform_now evidence, user.id
  end
end
