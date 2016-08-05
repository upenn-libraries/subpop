require 'rails_helper'

RSpec.describe DeletePublishableJob, type: :job do
  let(:evidence) { create(:evidence) }

  it 'enquues the job' do
    ActiveJob::Base.queue_adapter = :test
    expect {
      DeletePublishableJob.perform_later evidence
    }.to have_enqueued_job(DeletePublishableJob).with evidence
  end

  it 'executes destroy' do
    expect(evidence).to receive(:destroy)
    described_class.perform_now evidence
  end

end
