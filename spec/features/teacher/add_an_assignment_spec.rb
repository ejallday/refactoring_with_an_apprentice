require 'spec_helper'

feature 'teacher adding an assignment' do
  scenario 'can create an assignment with valid attributes' do
    teacher = create(:teacher)
    create(:course, name: 'Science', teacher: teacher)
    assigned_on = Date.parse('January, 15, 2014')
    due_on = Date.parse('January, 17, 2014')

    visit new_teacher_assignment_path(as: teacher)

    within_form(:assignment) do |f|
      f.select_from_dropdown(:course_id, 'Science')
      f.fill_in_text_field(:name, 'Pop Quiz')
      f.fill_in_text_field(:description, 'I hope you studied!')
      f.fill_in_text_field(:points_possible, 100)
      f.select_date(:assigned_on, assigned_on)
      f.select_date(:due_on, due_on)
    end
    click_button I18n.t('helpers.submit.create', model: 'Assignment')

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
    delegate :select, :fill_in, to: :context

    def initialize(prefix, context)
      @prefix = prefix
      @context = context
    end

    def fill_in_text_field(field, value)
      fill_in "#{ prefix }_#{ field }", with: value
    end

    def select_date(field, date)
      select date.year, from: :"#{ prefix }_#{ field }_1i"
      select date.strftime('%B'), from: :"#{ prefix }_#{ field }_2i"
      select date.day, from: :"#{ prefix }_#{ field }_3i"
    end

    def select_from_dropdown(field, value)
      select value, from: :"#{ prefix }_#{ field }"
    end

    private

    attr_reader :prefix, :context
  end
end
