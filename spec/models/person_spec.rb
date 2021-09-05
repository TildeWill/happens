require 'rails_helper'

RSpec.describe Person, type: :model do
  it "let's the developer create a linked list of changes to a Person" do
    boss = Person.create(first_name: "The", last_name: "Shredder", title: "Head Boss", effective_on: Date.today)
    boss.title = "Mega Boss"
    boss.effective_on = Date.tomorrow
    boss.parent = boss
    HistorizeService.update(boss)

    expect(boss.title).to eq("Mega Boss")
    expect(boss.parent.title).to eq("Head Boss")
  end

  it "can finds the leaf for the right time on or before a certain date" do
    boss = Person.create!(title: "Head Boss1", effective_on: 1.day.from_now)
    boss.title = "Head Boss2"
    boss.effective_on = 2.days.from_now
    HistorizeService.update(boss)
    boss.title = "Head Boss3"
    boss.effective_on = 3.days.from_now
    HistorizeService.update(boss)

    leaf = Person.for(1.day.from_now).first
    expect(leaf.title).to eq("Head Boss1")
    leaf = Person.for(4.days.from_now).first
    expect(leaf.title).to eq("Head Boss3")
  end

  it "finds all the leaves for the right time" do
    boss = Person.create(first_name: "The", last_name: "Shredder", title: "Head Boss1")
    boss.title = "Head Boss2"
    HistorizeService.update(boss)

    underling = Person.create(first_name: "Foot", last_name: "Soilder", title: "Underling1")
    underling.title = "Underling2"
    HistorizeService.update(underling)
  end
end
