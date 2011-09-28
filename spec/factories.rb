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

Factory.define :sector do |sector|
  sector.sector		     "Defence"
end

Factory.define :business do |business|
  business.name		     "Cambiz"
  business.address	     "34 Walpole Road, Cambridge"
  business.city	     	     "Cambridge"
  business.country           "United Kingdom"
  business.latitude          52.1877923
  business.longitude         0.1623374
  business.association :sector
end

Factory.define :employee do |employee|
  employee.association :user
  employee.association :business
end

#Factory.define :plan do |plan|
#  plan.association :job
#end

Factory.define :responsibility do |responsibility|
  responsibility.association :plan
  responsibility.definition 	"Responsibility 1"
  responsibility.created_by     1
  responsibility.rating		0
end

Factory.define :goal do |goal|
  goal.association :responsibility
  goal.objective	"Objective 1"
  goal.created_by	1
end

Factory.define :quality do |quality|
  quality.quality		"First quality"
  quality.created_by		1
end

Factory.define :pam do |pam|
  pam.association :quality
  pam.grade			"A"
  pam.descriptor		"Grade for A"
end

Factory.define :jobquality do |jobquality|
  jobquality.association :plan
  jobquality.association :quality
end

Factory.sequence :email do |n|
  "person-#{n}@example.com"
end

Factory.sequence :job_title do |j|
  "job-#{j}"
end

Factory.sequence :definition do |d|
  "Definition-#{d}"
end

Factory.sequence :quality do |q|
  "Quality-#{q}"
end
