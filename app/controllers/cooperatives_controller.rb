class CooperativesController < ApplicationController
	prepend_before_filter :authenticate_user!
	before_filter :ensure_cooperative_admin
	before_action :set_cooperative

	def edit
		@activities = @cooperative.activities.order(activated: :desc)
		@destroy_members_form = DestroyMembersPresenter.new
	end

	def update
		if @cooperative.update(cooperative_params)
			redirect_to edit_cooperative_path(@cooperative)
		else
			render nothing: true, status: 401
		end
	end

	def destroy_old_members
		day_month_year = destroy_members_param.values.map {|val| val.to_i}
		date = Date.new(day_month_year.last, day_month_year.second, day_month_year.first)
		Member.where("created_at < ?", date).destroy_all
		redirect_to edit_cooperative_path(@cooperative)

	end

	def import
		if !params[:file].nil? && params[:file].original_filename.end_with?(".csv")
			import = Import.new(params[:file], current_user.cooperative)
			failed_imports = import.import
			flash[:warning] = t('import.failed_members', row: failed_imports.join(", ")) unless failed_imports.empty?
		else
			flash[:danger] = t('import.no_file') if params[:file].nil?
			flash[:danger] = t('import.not_csv') if !params[:file].nil? && !params[:file].original_filename.end_with?(".csv")
		end
		redirect_to edit_cooperative_path(@cooperative)
	end

	def export
		@members = Member.order(:name)
		respond_to do |format|
      format.html
	    format.csv { send_data @members.as_csv }
    end
	end

	private

	def cooperative_params
		params.require(:cooperative).permit(:name)
	end

	def destroy_members_param
		params.require(:destroy_members_presenter).permit('date(3i)', 'date(2i)', 'date(1i)')
	end
end
