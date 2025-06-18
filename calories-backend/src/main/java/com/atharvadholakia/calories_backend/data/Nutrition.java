package com.atharvadholakia.calories_backend.data;

import com.fasterxml.jackson.annotation.JsonInclude;

@JsonInclude(JsonInclude.Include.NON_NULL)
public class Nutrition {

  public Nutrition() {}

  private String food;
  private double energy;
  private double protein;
  private double fat;
  private double carbohydrates;
  private double sugar;

  public String getFood() {
    return this.food;
  }

  public double getEnergy() {
    return this.energy;
  }

  public double getProtein() {
    return this.protein;
  }

  public double getFat() {
    return this.fat;
  }

  public double getCarbohydrates() {
    return this.carbohydrates;
  }

  public double getSugar() {
    return this.sugar;
  }

  public void setFood(String food) {
    this.food = food;
  }

  public void setEnergy(double energy) {
    this.energy = energy;
  }

  public void setProtein(double protein) {
    this.protein = protein;
  }

  public void setFat(double fat) {
    this.fat = fat;
  }

  public void setCarbohydrates(double carbohydrates) {
    this.carbohydrates = carbohydrates;
  }

  public void setSugar(double sugar) {
    this.sugar = sugar;
  }
}
