require 'rails_helper'

RSpec.describe RemoveFromFlickrJob, type: :job do
  let(:evidence) { create(:evidence) }

  it 'enquues the job' do
    ActiveJob::Base.queue_adapter = :test
    expect {
      RemoveFromFlickrJob.perform_later evidence
    }.to have_enqueued_job(RemoveFromFlickrJob).with evidence
  end

  it 'executes delete_from_flickr' do
    expect(evidence).to receive(:delete_from_flickr)
    expect(evidence).to receive(:save!)
    described_class.perform_now evidence
  end
end
