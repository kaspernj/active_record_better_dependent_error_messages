require "rails_helper"

describe "dependent error messages" do
  let(:account) { create :account, id: 1 }
  let(:project) { create :project, account: account, id: 2 }
  let(:task) { create :task, id: 3, project: project }

  it "adds an error message" do
    task

    expect(account.destroy).to be_falsey
    expect(account.errors.full_messages).to eq ["Cannot delete because of Account(1) -> Project(2) has dependent records: tasks with IDs: 3"]
  end
end
