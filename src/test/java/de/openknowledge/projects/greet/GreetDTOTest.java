/*
 * Copyright (C) open knowledge GmbH
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing,
 * software distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions
 * and limitations under the License.
 */
package de.openknowledge.projects.greet;

import static org.assertj.core.api.Assertions.assertThat;
import static org.assertj.core.api.Assertions.assertThatNullPointerException;

import org.junit.jupiter.api.Test;

/**
 * Test class for the DTO {@link GreetDTO}.
 */
public class GreetDTOTest {

  @Test
  public void instantiationShouldFailForMissingValue() {
    assertThatNullPointerException()
        .isThrownBy(() -> new GreetDTO(null))
        .withMessage("message must not be null")
        .withNoCause();
  }

  @Test
  public void instantiationShouldSucceed() {
    GreetDTO greet = new GreetDTO("Hello Stephan!");
    assertThat(greet.getMessage()).isEqualTo("Hello Stephan!");
  }
}
