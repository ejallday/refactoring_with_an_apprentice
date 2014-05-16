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
end
