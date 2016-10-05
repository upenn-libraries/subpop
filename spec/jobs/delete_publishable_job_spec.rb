require 'rails_helper'

RSpec.describe DeletePublishableJob, type: :job do
  # make sure the photo is orphaned
  let(:photo)    { create(:photo, book: nil) }
  let(:evidence) { create(:evidence, photo: photo) }
  let(:user)     { create(:user) }

  it 'enquues the job' do
    ActiveJob::Base.queue_adapter = :test
    expect {
      DeletePublishableJob.perform_later evidence
    }.to have_enqueued_job(DeletePublishableJob).with evidence
  end

  it 'executes destroy' do
    expect(evidence).to receive(:destroy)
    described_class.perform_now evidence, user
  end

  it 'destroys the photo' do
    expect(photo).to receive(:destroy)
    DeletePublishableJob.perform_now evidence, user
  end

end
