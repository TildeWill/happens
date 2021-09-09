require 'rails_helper'

RSpec.describe Person do
  it "inserts brand new models in the right place in the tree" do
    person = Person.create(effective_on: Date.current, first_name: "Will", last_name: "Read")
    expect(person.path.length).to eq(1)
    expect(person.children.length).to eq(0)
    expect(PersonContent.count).to eq(1)

    person.update(effective_on: 2.days.from_now)
    expect(person.path.length).to eq(2)
    expect(person.children.length).to eq(0)
    expect(PersonContent.count).to eq(2)

    person.update(effective_on: 1.day.from_now)
    expect(person.path.length).to eq(2) #because it was inserted in the middle
    expect(person.children.length).to eq(1) #because it was inserted in the middle
    expect(PersonContent.count).to eq(3)

    expect(Leaf.all.map(&:furcate_identifier).uniq).not_to be_nil
  end

  it "maintains the furcate_identifier across multiple leaves" do
    person = Person.create(effective_on: Date.current, first_name: "Will", last_name: "Read")
    person.update(effective_on: 2.days.from_now)
    person.update(effective_on: 1.day.from_now)

    expect(Leaf.all.map(&:furcate_identifier).uniq.length).to eq(1)
    expect(Leaf.all.map(&:furcate_identifier).uniq).not_to be_nil
  end
end
