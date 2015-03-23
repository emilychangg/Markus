require 'spec_helper'

describe GradeEntryFormsController do
  before :each do
    # Authenticate user is not timed out, and has administrator rights.
    allow(controller).to receive(:session_expired?).and_return(false)
    allow(controller).to receive(:logged_in?).and_return(true)
    allow(controller).to receive(:current_user).and_return(build(:admin))
  end

  let(:grade_entry_form) { create(:grade_entry_form) }
  let(:grade_entry_form_with_data) { create(:grade_entry_form_with_data) }

  context 'CSV_Uploads' do
    before :each do
      @file_without_extension =
        fixture_file_upload('spec/fixtures/files/grade_entry_upload_empty_file',
                            'text/xml')
      @file_wrong_format =
        fixture_file_upload(
          'spec/fixtures/files/grade_entry_upload_wrong_format.xls', 'text/xls')
      @file_bad_csv =
        fixture_file_upload(
          'spec/fixtures/files/grade_entry_upload_bad_csv.csv', 'text/xls')
      @file_non_empty_first_cell =
        fixture_file_upload(
          'spec/fixtures/files/grade_entry_upload_non_empty_first_cell.csv',
          'text/csv')
      @file_invalid_username =
        fixture_file_upload(
          'spec/fixtures/files/grade_entry_form_invalid_username.csv',
          'text/csv')
      @file_extra_column =
        fixture_file_upload(
          'spec/fixtures/files/grade_entry_form_extra_column.csv',
          'text/csv')
      @file_wrong_column_name =
        fixture_file_upload(
          'spec/fixtures/files/grade_entry_form_wrong_column_name.csv',
          'text/csv')
      @file_wrong_total =
        fixture_file_upload(
          'spec/fixtures/files/grade_entry_form_wrong_total.csv',
          'text/csv')
      @file_good =
        fixture_file_upload(
          'spec/fixtures/files/grade_entry_form_good.csv',
          'text/csv')
    end

    it 'accepts valid file' do
      post :csv_upload,
           id: grade_entry_form_with_data,
           upload: { grades_file: @file_good }
      expect(response.status).to eq(302)
      expect(flash[:error]).to be_nil
      expect(response).to redirect_to(
        grades_grade_entry_form_path(grade_entry_form_with_data, locale: 'en'))
    end

    it 'does not accept csv file with an invalid username' do
      post :csv_upload,
           id: grade_entry_form_with_data,
           upload: { grades_file: @file_invalid_username }
      expect(response.status).to eq(302)
      expect(flash[:error]).to_not be_empty
      puts flash[:error]
      expect(response).to redirect_to(
        grades_grade_entry_form_path(grade_entry_form_with_data, locale: 'en'))
    end

    it 'does not accept files with additional columns' do
      post :csv_upload,
           id: grade_entry_form_with_data,
           upload: { grades_file: @file_extra_column }
      expect(response.status).to eq(302)
      expect(flash[:error]).to be_nil
      expect(response).to redirect_to(
        grades_grade_entry_form_path(grade_entry_form_with_data, locale: 'en'))
    end

    it 'does not accept files with wrong column name' do
      post :csv_upload,
           id: grade_entry_form_with_data,
           upload: { grades_file: @file_wrong_column_name }
      expect(response.status).to eq(302)
      expect(flash[:error]).to be_nil
      expect(response).to redirect_to(
        grades_grade_entry_form_path(grade_entry_form_with_data, locale: 'en'))
    end

    it 'does not accept files with wrong grade total' do
      post :csv_upload,
           id: grade_entry_form_with_data,
           upload: { grades_file: @file_wrong_total }
      expect(response.status).to eq(302)
      expect(flash[:error]).to be_nil
      expect(response).to redirect_to(
        grades_grade_entry_form_path(grade_entry_form_with_data, locale: 'en'))
    end

    # this test is currently failing.
    # issue #2078 has been opened to resolve this
    # it 'does not accept a csv file with wrong data columns' do
    #  post :csv_upload, id: grade_entry_form,
    #       upload: { :grades_file => @file_non_empty_first_cell }
    # expect(response.status).to eq(302)
    # expect(flash[:error]).to_not be_empty
    # expect(response).to redirect_to(
    #   grades_grade_entry_form_path(grade_entry_form, locale: 'en'))
    # end

    it 'does not accept a file with no extension' do
      post :csv_upload,
           id: grade_entry_form,
           upload: { grades_file: @file_without_extension }
      expect(response.status).to eq(302)
      expect(flash[:error]).to_not be_empty
      expect(response).to redirect_to(
        grades_grade_entry_form_path(grade_entry_form, locale: 'en'))
    end

    it 'does not accept fileless submission' do
      post :csv_upload, id: grade_entry_form
      expect(response.status).to eq(302)
      expect(flash[:error]).to_not be_empty
      expect(response).to redirect_to(
        grades_grade_entry_form_path(grade_entry_form, locale: 'en'))
    end

    it 'should gracefully fail on non-csv file with .csv extension' do
      post :csv_upload, id: grade_entry_form,
           upload: { grades_file: @file_bad_csv }
      expect(response.status).to eq(302)
      expect(flash[:error]).to_not be_empty
      expect(response).to redirect_to(
        grades_grade_entry_form_path(grade_entry_form, locale: 'en'))
    end

    it 'should gracefully fail on .xls file' do
      post :csv_upload,
           id: grade_entry_form,
           upload: { grades_file: @file_wrong_format }
      expect(response.status).to eq(302)
      expect(flash[:error]).to_not be_empty
      expect(response).to redirect_to(
        grades_grade_entry_form_path(grade_entry_form, locale: 'en'))
    end
  end

  context 'CSV_Downloads' do
    let(:csv_data) { grade_entry_form.get_csv_grades_report }
    let(:csv_options) do
      {
        filename: "#{grade_entry_form.short_identifier}_grades_report.csv",
        disposition: 'attachment',
        type: 'application/vnd.ms-excel'
      }
    end

    it 'tests that action csv_downloads returns OK' do
      get :csv_download, id: grade_entry_form
      expect(response.status).to eq(200)
    end

    it 'expects a call to send_data' do
      expect(@controller).to receive(:send_data).with(csv_data, csv_options) {
        # to prevent a 'missing template' error
        @controller.render nothing: true
      }
      get :csv_download, id: grade_entry_form
    end

    # parse header object to check for the right disposition
    it 'sets disposition as attachment' do
      get :csv_download, id: grade_entry_form
      d = response.header['Content-Disposition'].split.first
      expect(d).to eq 'attachment;'
    end

    # parse header object to check for the right content type
    it 'returns vnd.ms-excel type' do
      get :csv_download, id: grade_entry_form
      expect(response.content_type).to eq 'application/vnd.ms-excel'
    end

    # parse header object to check for the right file naming convention
    it 'filename passes naming conventions' do
      get :csv_download, id: grade_entry_form
      filename = response.header['Content-Disposition']
                 .split.last.split('"').second
      expect(filename).to eq "#{grade_entry_form.short_identifier}" +
        '_grades_report.csv'
    end
  end
end
