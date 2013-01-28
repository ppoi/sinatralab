# -*- encoding: utf-8 -*-
class Label < Sequel::Model

  def self.get(name)
    Label.dataset.where(:name =>name).first
  end

  def self.all
    Label.dataset.order(:name).all
  end
end
