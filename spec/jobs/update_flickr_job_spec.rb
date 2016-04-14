require 'rails_helper'

RSpec.describe UpdateFlickrJob, type: :job do
  let(:evidence) { create(:evidence) }

  it 'enquues the job' do
    ActiveJob::Base.queue_adapter = :test
    expect {
      UpdateFlickrJob.perform_later evidence
    }.to have_enqueued_job(UpdateFlickrJob).with evidence
  end

  it 'executes republish!' do
    expect(evidence).to receive(:republish!)
    described_class.perform_now evidence
  end

end
