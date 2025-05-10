package com.atharvadholakia.calories_backend.data;

public class Nutrition {

  public Nutrition() {}

  private String food;
  private String energy;
  private String protein;
  private String fat;
  private String carbohydrates;
  private String sugar;

  public String getFood() {
    return this.food;
  }

  public String getEnegery() {
    return this.energy;
  }

  public String getProtein() {
    return this.protein;
  }

  public String getFat() {
    return this.fat;
  }

  public String getCarbohydrates() {
    return this.carbohydrates;
  }

  public String getSugar() {
    return this.sugar;
  }

  public void setFood(String food) {
    this.food = food;
  }

  public void setEnergy(String energy) {
    this.energy = energy;
  }

  public void setProtein(String protein) {
    this.protein = protein;
  }

  public void setFat(String fat) {
    this.fat = fat;
  }

  public void setCarbohydrated(String carbohydrates) {
    this.carbohydrates = carbohydrates;
  }

  public void setSugar(String sugar) {
    this.sugar = sugar;
  }
}
