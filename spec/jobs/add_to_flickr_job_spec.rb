require 'rails_helper'

RSpec.describe AddToFlickrJob, type: :job do

  let(:evidence) { create(:evidence) }
  subject(:job) { described_class.perform_later evidence }

  it 'enquues the job' do
    ActiveJob::Base.queue_adapter = :test
    expect {
      AddToFlickrJob.perform_later evidence
    }.to have_enqueued_job(AddToFlickrJob).with evidence
  end

  it 'executes publish_new!' do
    expect(evidence).to receive(:publish_new!)
    described_class.perform_now evidence
  end
end
