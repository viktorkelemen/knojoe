module VillagesHelper
  def villager_count(village)
    pluralize(village.villagers_count, 'village')
  end
end
