require "rails_helper"

describe ActiveRecordBetterDependentErrorMessages::SaveModule do
  let(:account) { create :account }
  let(:project) { create :project, account: account }
  let(:task) { create :task, project: project }

  it "adds an error message on the account" do
    task

    params = {
      projects_attributes: {
        1 => {
          id: project.id,
          _destroy: true
        }
      }
    }

    expect(account.update(params)).to be_falsey
    expect(account.errors.full_messages).to eq ["Cannot delete record because dependent tasks exist"]
  end
end
