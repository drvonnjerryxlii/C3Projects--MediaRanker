class MediaController < ApplicationController
  # before_action :set_category

  def root
    @categorized_records = Medium.categorize
  end

  def index
    set_category

    @all_records = Medium.grab_category(@singular_category)
  end

  def show
    @current_record = Medium.find(params[:id])
  end

  def new
    set_category
    @medium = Medium.new(category: @singular_category)
    set_creator(@medium)
  end

  def edit
    @medium = Medium.find(params[:id])
  end

  def upvote
    medium = Medium.find(params[:id])
    medium.increment!(:upvotes, 1)

    redirect_to "/#{ medium.plural_category }/#{ medium.id }"
  end

  def update
    medium = Medium.find(params[:id])
    if medium.update!(edit_params)
      redirect_to "/#{ medium.plural_category }/#{ medium.id}"
    else
      redirect_to "/#{ medium.plural_category }/#{ medium.id}/edit"
    end
  end

  def create
    medium = Medium.new(create_params)

    if medium.valid?
      medium.save

      redirect_to "/#{ medium.plural_category }/#{ medium.id }"
    else
      redirect_to "/#{ medium.plural_category }/new"
    end
  end

  def destroy
    medium = Medium.find(params[:id])
    category = medium.plural_category
    medium.destroy

    redirect_to "/#{ category }"
  end

  private

  def create_params
    stuff = edit_params
    stuff[:medium][:upvotes] = 0

    return stuff
  end

  def edit_params
    params.permit(medium: [:title, :creator, :description, :category])[:medium]
  end

  def set_category
    @category = params[:category]
    @singular_category = singular_category(@category)
  end

  def singular_category(plural)
    return plural.classify
  end

  def set_creator(categorized_medium)
    @creator = categorized_medium.creator_noun
    @created = categorized_medium.created
  end
end
