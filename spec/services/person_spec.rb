require 'rails_helper'

RSpec.describe Person do
  it "inserts brand new models in the right place in the tree" do
    manager = nil
    person = nil

    expect {
      manager = Person.create(effective_date: Date.current.to_date, first_name: "Jessica", last_name: "Atreides")
    }.to change(PersonContent, :count).by(1)

    expect {
      person = Person.create(effective_date: Date.current.to_date, first_name: "Paul", last_name: "Atreides", manager: manager)
    }.to change(PersonContent, :count).by(1)

    expect(person.path.length).to eq(2)
    expect(person.children.length).to eq(0)

    expect {
      person.update(effective_date: 2.days.from_now.to_date, last_name: "Muad'Dib")
    }.to change(PersonContent, :count).by(1)
    expect(person.path.length).to eq(3)
    expect(person.children.length).to eq(0)

    expect {
      person.update(effective_date: 1.day.from_now.to_date, manager: nil)
    }.to change(PersonContent, :count).by(1)

    expect(person.path.length).to eq(3) #because it was inserted in the middle
    expect(person.children.length).to eq(1) #because it was inserted in the middle

    leaves = Person.find_for(3.day.from_now.to_date)
    expect(leaves.length).to eq(2)
  end

  it "maintains the furcate_identifier across multiple leaves" do
    person = Person.create(effective_date: Date.current, first_name: "Will", last_name: "Read")
    person.update(effective_date: 2.days.from_now)
    person.update(effective_date: 1.day.from_now)

    expect(Leaf.all.map(&:furcate_identifier).uniq.length).to eq(1)
    expect(Leaf.all.map(&:furcate_identifier).uniq).not_to be_nil
  end
end
