require 'spec_helper'

feature 'teacher adding an assignment' do
  scenario 'can create an assignment with valid attributes' do
    teacher = create(:teacher)
    course1 = create(:course, name: 'Math', teacher: teacher)
    course2 = create(:course, name: 'Science', teacher: teacher)
    course3 = create(:course, name: 'History', teacher: teacher)
    course4 = create(:course, name: 'Quantum Physics', teacher: teacher)

    visit new_teacher_assignment_path(as: teacher)

    select 'Science', from: :assignment_course_id
    fill_in :assignment_name, with: 'Pop Quiz'
    fill_in :assignment_description, with: 'I hope you studied!'
    select '2014', from: :assignment_date_assigned_1i
    select 'January', from: :assignment_date_assigned_2i
    select '15', from: :assignment_date_assigned_3i
    select '2014', from: :assignment_date_due_1i
    select 'January', from: :assignment_date_due_2i
    select '17', from: :assignment_date_due_3i
    fill_in :assignment_points_possible, with: 100
    click_button I18n.t('helpers.submit.create', model: 'Assignment')

    expect(current_path).to eq(teacher_assignments_path)
    expect(page).to have_content('Course: Science')
    expect(page).to have_content('Name: Pop Quiz')
    expect(page).to have_content('Description: I hope you studied!')
    expect(page).to have_content('Date assigned: January 15, 2014')
    expect(page).to have_content('Date due: January 17, 2014')
    expect(page).to have_content('Points possible: 100')
  end
end
