require 'spec_helper'

feature 'teacher adding an assignment' do
  scenario 'can create an assignment with valid attributes' do
    teacher = create(:teacher)
    create(:course, name: 'Science', teacher: teacher)
    assigned_on = Date.parse('January, 15, 2014')
    due_on = Date.parse('January, 17, 2014')

    visit new_teacher_assignment_path(as: teacher)

    within_form(:assignment) do |f|
      f.select_from_dropdown(course_id: 'Science')
      f.fill_in_text_fields(
        name: 'Pop Quiz',
        description: 'I hope you studied!',
        points_possible: 100
      )
      f.select_dates(
        assigned_on: assigned_on,
        due_on: due_on
      )
      f.submit(:create)
    end

    expect(current_path).to eq(teacher_assignments_path)
    expect(page).to have_content('Course: Science')
    expect(page).to have_content('Name: Pop Quiz')
    expect(page).to have_content('Description: I hope you studied!')
    expect(page).to have_content('Assigned on: January 15, 2014')
    expect(page).to have_content('Due on: January 17, 2014')
    expect(page).to have_content('Points possible: 100')
  end

  def within_form(prefix, &block)
    completion_helper = FormCompletionHelper.new(form_prefix, self)
    yield completion_helper
  end

  class FormCompletionHelper
    delegate :select, :fill_in, :click_button, to: :context

    def initialize(prefix, context)
      @prefix = prefix
      @context = context
    end

    def fill_in_text_field(options)
      options.each do |field, value|
        fill_in "#{ prefix }_#{ field }", with: value
      end
    end
    alias :fill_in_text_fields :fill_in_text_field

    def select_date(options)
      options.each do |field, value|
        select date.year, from: :"#{ prefix }_#{ field }_1i"
        select date.strftime('%B'), from: :"#{ prefix }_#{ field }_2i"
        select date.day, from: :"#{ prefix }_#{ field }_3i"
      end
    end
    alias :select_dates :select_date

    def select_from_dropdown(options)
      options.each do |field, value|
        select value, from: :"#{ prefix }_#{ field }"
      end
    end
    alias :select_from_dropdowns :select_from_dropdown

    def submit(create_or_update)
      raise InvalidArgumentException unless [:create, :update].include?(create_or_update.to_sym)
      click_button I18n.t("helpers.submit.#{ create_or_update }", model: model_name)
    end

    private

    def model_name
      prefix.to_s.capitalize
    end

    attr_reader :prefix, :context
  end
end
