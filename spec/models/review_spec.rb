require 'spec_helper'

describe Review do
  it { should belong_to(:creator).dependent(:destroy) }
  it { should belong_to(:video).dependent(:destroy) }
  it { should validate_presence_of :body }
  it { should validate_presence_of :rating }
  it { should validate_inclusion_of(:rating).in_array([1, 2, 3, 4, 5]) }
end
