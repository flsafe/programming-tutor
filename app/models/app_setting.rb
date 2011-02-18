class AppSetting < ActiveRecord::Base  
  validates_presence_of :setting
  validates_uniqueness_of :setting

  @@beta_capacity_default = 50

  def self.spec(setting_name, value)
    settings = {}
    settings[:setting] = setting_name
    if value.is_a? Integer
      settings[:int_value] = value
    elsif value.is_a? Float
      settings[:flt_value] = value
    elsif value.is_a? String
      settings[:str_value] = value
    end

    s = AppSetting.new settings 
    s.save!
    s
  end

  def self.beta_capacity
    # TODO: Add these functions like this one dynamically based on 
    # the AppSettings database table rows.
    s = AppSetting.find_by_setting('beta_capacity')
    if s
      s.value
    else
      AppSetting.spec('beta_capacity', @@beta_capacity_default).value
    end
  end

  def value
    return int_value if int_value
    return flt_value if flt_value
    return str_value if str_value
    nil
  end
end
