require 'rails_helper'

RSpec.describe UpdateFlickrJob, type: :job do
  let(:user)     { create :user }
  let(:evidence) { create(:evidence) }

  it 'enquues the job' do
    ActiveJob::Base.queue_adapter = :test
    expect {
      UpdateFlickrJob.perform_later evidence, user.id
    }.to have_enqueued_job(UpdateFlickrJob).with evidence, user.id
  end

  it 'executes republish' do
    expect(evidence).to receive(:republish)
    described_class.perform_now evidence, user.id
  end

end
