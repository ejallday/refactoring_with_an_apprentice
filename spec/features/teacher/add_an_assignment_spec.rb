require 'spec_helper'

feature 'teacher adding an assignment' do
  scenario 'can create an assignment with valid attributes' do
    teacher = create(:teacher)
    create(:course, name: 'Science', teacher: teacher)
    assigned_on = Date.parse('January, 15, 2014')
    due_on = Date.parse('January, 17, 2014')

    visit new_teacher_assignment_path(as: teacher)

    select 'Science', from: :assignment_course_id
    fill_in_text_field(:assignment, :name, 'Pop Quiz')
    fill_in_text_field(:assignment, :description, 'I hope you studied!')
    select_date(:assignment, :assigned_on, assigned_on)
    select_date(:assignment, :due_on, due_on)
    fill_in_text_field(:assignment,:points_possible, 100)
    click_button I18n.t('helpers.submit.create', model: 'Assignment')

    expect(current_path).to eq(teacher_assignments_path)
    expect(page).to have_content('Course: Science')
    expect(page).to have_content('Name: Pop Quiz')
    expect(page).to have_content('Description: I hope you studied!')
    expect(page).to have_content('Assigned on: January 15, 2014')
    expect(page).to have_content('Due on: January 17, 2014')
    expect(page).to have_content('Points possible: 100')
  end

  def fill_in_text_field(prefix, field, value)
    fill_in "#{ prefix }_#{ field }", with: value
  end

  def select_date(prefix, field, date)
    select date.year, from: :"#{ prefix }_#{ field }_1i"
    select date.strftime('%B'), from: :"#{ prefix }_#{ field }_2i"
    select date.day, from: :"#{ prefix }_#{ field }_3i"
  end
end
