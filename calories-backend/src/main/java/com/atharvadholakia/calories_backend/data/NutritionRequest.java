package com.atharvadholakia.calories_backend.data;

import java.util.List;

public class NutritionRequest {
  private final List<Content> contents;

  public NutritionRequest(List<Content> contents) {
    this.contents = contents;
  }

  public List<Content> getContents() {
    return contents;
  }

  public static class Content {
    private final List<Part> parts;

    public Content(List<Part> parts) {
      this.parts = parts;
    }

    public List<Part> getParts() {
      return parts;
    }
  }

  public interface Part {}

  public static class TextPart implements Part {
    private final String text;

    public TextPart(String text) {
      this.text = text;
    }

    public String getText() {
      return text;
    }
  }

  public static class ImagePart implements Part {
    private final InlineData inlineData;

    public ImagePart(InlineData inlineData) {
      this.inlineData = inlineData;
    }

    public InlineData getInlineData() {
      return inlineData;
    }
  }

  public static class InlineData {
    private final String mimeType;
    private final String data;

    public InlineData(String mimeType, String data) {
      this.mimeType = mimeType;
      this.data = data;
    }

    public String getMimeType() {
      return mimeType;
    }

    public String getData() {
      return data;
    }
  }
}
