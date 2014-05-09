require 'spec_helper'

feature 'teacher adding an assignment' do
  scenario 'can create an assignment with valid attributes' do
    teacher = create(:teacher)
    create(:course, name: 'Science', teacher: teacher)

    visit new_teacher_assignment_path(as: teacher)

    select 'Science', from: :assignment_course_id
    fill_in :assignment_name, with: 'Pop Quiz'
    fill_in :assignment_description, with: 'I hope you studied!'
    select_date(:assignment, :assigned_on, 'January 15, 2014')
    select_date(:assignment, :due_on, 'January 17, 2014')
    fill_in :assignment_points_possible, with: 100
    click_button I18n.t('helpers.submit.create', model: 'Assignment')

    expect(current_path).to eq(teacher_assignments_path)
    expect(page).to have_content('Course: Science')
    expect(page).to have_content('Name: Pop Quiz')
    expect(page).to have_content('Description: I hope you studied!')
    expect(page).to have_content('Assigned on: January 15, 2014')
    expect(page).to have_content('Due on: January 17, 2014')
    expect(page).to have_content('Points possible: 100')
  end

  def select_date(prefix, field, date)
    parsed_date = Date.parse(date)
    select parsed_date.year, from: :"#{ prefix }_#{ field }_1i"
    select parsed_date.strftime('%B'), from: :"#{ prefix }_#{ field }_2i"
    select parsed_date.day, from: :"#{ prefix }_#{ field }_3i"
  end
end
