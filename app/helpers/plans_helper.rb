module PlansHelper
  
  def init_plan
    @phase=[["operating","operating"],["brainstorm","brainstorm"],["study","study"],["requirement","requirement"],["design","design"],["prototype","prototype"],
    ["refactor","refactor"],["test","test"],["deploy","deploy"],["notes","notes"],["others","others"]]
    @delivers=[["plan-do-check","plan-do-check"],["code","code"],["code-doc","code-doc"],["offline-doc","offline-doc"]]
    @plan_users=[["hunter","hunter"],["steven","steven"]]
  end

end
