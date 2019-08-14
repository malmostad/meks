RSpec.describe GenerateReportJob, type: :job do
  let(:valid_attributes) {
    { homes_free_seats: '', homes_owner_type: '', report_type: 'homes' }
  }

  describe 'queue a report' do
    it 'creates a ActiveJob ID' do
      job = GenerateReportJob::Homes.perform_later(valid_attributes, 'test_file')
      expect(job.provider_job_id).to be_a Integer
    end

    it 'creates a delayed job id' do
      job = GenerateReportJob::Homes.perform_later(valid_attributes, 'test_file')
      delayed_job_id = Delayed::Job.find(job.provider_job_id).id
      expect(delayed_job_id).to be_a Integer
    end

    it 'creates a delayed job id' do
      job = GenerateReportJob::Homes.perform_later(valid_attributes, 'test_file')
      delayed_job_id = Delayed::Job.find(job.provider_job_id).id
      expect(delayed_job_id).to be_a Integer
    end

    it 'adds it to the queue' do
      expect {
        GenerateReportJob::Homes.perform_later(valid_attributes, 'test_file')
      }.to change(Delayed::Job, :count).by(1)
    end

    describe 'works the queue off' do
      it 'returns 1 succeess and 0 failures' do
        GenerateReportJob::Homes.perform_later(valid_attributes, 'test_file')
        expect(Delayed::Worker.new.work_off).to eq [1, 0]
      end

      it 'generates a valid xlsx file' do
        filename = File.join(Rails.root, 'reports', 'test_file.xlsx')
        FileUtils.rm_rf filename
        GenerateReportJob::Homes.perform_later(valid_attributes, 'test_file')
        Delayed::Worker.new.work_off
        expect(File.read(filename)[0..1]).to eq 'PK' # An xlsx is packed as a zip file
      end
    end
  end
end
