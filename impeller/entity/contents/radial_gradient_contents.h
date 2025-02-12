// Copyright 2013 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

#pragma once

#include <functional>
#include <memory>
#include <vector>

#include "flutter/fml/macros.h"
#include "impeller/entity/contents/path_contents.h"
#include "impeller/geometry/color.h"
#include "impeller/geometry/path.h"
#include "impeller/geometry/point.h"

namespace impeller {

class RadialGradientContents final : public PathContents {
 public:
  RadialGradientContents();

  ~RadialGradientContents() override;

  void SetPath(Path path) override;

  // |Contents|
  std::optional<Rect> GetCoverage(const Entity& entity) const override;

  // |Contents|
  bool Render(const ContentContext& renderer,
              const Entity& entity,
              RenderPass& pass) const override;

  void SetCenterAndRadius(Point centre, Scalar radius);

  void SetColors(std::vector<Color> colors);

  const std::vector<Color>& GetColors() const;

 private:
  Path path_;
  Point center_;
  Scalar radius_;
  std::vector<Color> colors_;

  FML_DISALLOW_COPY_AND_ASSIGN(RadialGradientContents);
};

}  // namespace impeller
