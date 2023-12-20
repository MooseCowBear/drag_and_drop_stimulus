module TasksHelper
  def category_color(category)
    colors = { 
      "work": "bg-emerald-400 text-white", 
      "personal": "bg-fuchsia-400 text-white", 
      "school": "bg-cyan-400 text-white" 
    }
    colors[category.to_sym] unless category.nil?
  end

  def priority_color(priority)
    colors = { 
      "low": "bg-green-200", 
      "medium": "bg-yellow-200", 
      "high": "bg-red-200" 
    }
    colors[priority.to_sym] unless priority.nil?
  end
end
