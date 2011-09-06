# By using the symbol ':user', we get Factory Girl to simulate the User model.
Factory.define :user do |user|
  user.name                  "Michael Hartl"
  user.email                 "mhartl@example.com"
  user.password              "foobar"
  user.password_confirmation "foobar"
end

Factory.define :occupation do |occupation|
  occupation.name	     "Sales"
end

Factory.define :job do |job|
  job.job_title		     "Sales Manager"
  job.association :business
  job.association :occupation
end

Factory.define :business do |business|
  business.name		     "Cambiz"
  business.address	     "34 Walpole Road, Cambridge"
  business.city	     	     "Cambridge"
  business.country           "United Kingdom"
  business.latitude          52.1877923
  business.longitude         0.1623374
end

Factory.define :employee do |employee|
  employee.association :user
  employee.association :business
end

Factory.sequence :email do |n|
  "person-#{n}@example.com"
end

Factory.sequence :job_title do |j|
  "job-#{j}"
end
