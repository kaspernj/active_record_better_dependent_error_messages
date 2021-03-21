require "rails_helper"

describe "dependent error messages" do
  let(:account) { create :account, id: 1 }
  let(:project) { create :project, account: account, id: 2 }
  let(:task) { create :task, id: 3, project: project }

  let(:second_project) { create :project, account: account, id: 4 }
  let(:second_task) { create :task, id: 5, project: second_project }

  it "adds an error message (and only once)" do
    task
    second_task

    expect(account.destroy).to be_falsey
    expect(account.errors.full_messages).to eq ["Cannot delete because of Account(1) -> Project(2) has dependent records: tasks with IDs: 3"]
  end

  it "adds base error messages" do
    create :project, account: account, id: 4849

    expect(account.destroy).to be_falsey
    expect(account.errors.full_messages).to eq ["Cannot delete because of child errors in projects with IDs: 4849: cannot delete project 4849"]
  end
end
