module VillagesHelper
  def villager_count(village)
    "#{village.villagers_count} #{'villager'.pluralize(village.villagers_count)}"
  end
end
