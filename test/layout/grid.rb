class TestGridLayout < MTest::Unit::TestCase
  def test_fixed_tracks_position_children
    layout = Panes.init(width: 40, height: 20)

    commands = layout.build(id: 'root', width: Panes::Sizing.grow, height: Panes::Sizing.grow) do
      ui(id: 'grid', width: Panes::Sizing.grow, height: Panes::Sizing.grow) do
        grid columns: '10 10', rows: '5 5' do
          area :top_left, row: 1, col: 1 do
            text 'TL', id: 'tl'
          end

          area :bottom_right, row: 2, col: 2 do
            text 'BR', id: 'br'
          end
        end
      end
    end

    top = find_command(commands, :top_left, :rectangle)
    bottom = find_command(commands, :bottom_right, :rectangle)
    tl_text = find_command(commands, 'tl', :text)
    br_text = find_command(commands, 'br', :text)

    assert_equal({ x: 0, y: 0, width: 10, height: 5 }, top[:bounding_box])
    assert_equal({ x: 10, y: 5, width: 10, height: 5 }, bottom[:bounding_box])
    assert_equal({ x: 0, y: 0, width: 2, height: 1 }, tl_text[:bounding_box])
    assert_equal({ x: 10, y: 5, width: 2, height: 1 }, br_text[:bounding_box])
  end

  def test_percent_and_fractional_tracks
    layout = Panes.init(width: 100, height: 40)

    commands = layout.build(id: 'root', width: Panes::Sizing.grow, height: Panes::Sizing.grow) do
      ui(id: 'metrics', width: Panes::Sizing.grow, height: Panes::Sizing.grow) do
        grid columns: '10 20% 1fr', rows: '3 1fr 3' do
          area :fixed, row: 1, col: 1 do
            text 'A'
          end

          area :mixed, row: 2, col: 2..3 do
            text 'Wide'
          end
        end
      end
    end

    fixed = find_command(commands, :fixed, :rectangle)
    mixed = find_command(commands, :mixed, :rectangle)

    assert_equal({ x: 0, y: 0, width: 10, height: 3 }, fixed[:bounding_box])
    assert_equal({ x: 10, y: 3, width: 90, height: 34 }, mixed[:bounding_box])
  end

  def test_spanning_with_gap
    layout = Panes.init(width: 50, height: 20)

    commands = layout.build(id: 'root', width: Panes::Sizing.grow, height: Panes::Sizing.grow) do
      ui(id: 'gap', width: Panes::Sizing.grow, height: Panes::Sizing.grow) do
        grid columns: '10 10 10', rows: '5 5', gap: 1 do
          area :header, row: 1, col: :all do
            text 'Header'
          end

          area :span, row: 2, col: 2..3 do
            text 'Body'
          end
        end
      end
    end

    header = find_command(commands, :header, :rectangle)
    span = find_command(commands, :span, :rectangle)

    assert_equal({ x: 0, y: 0, width: 32, height: 5 }, header[:bounding_box])
    assert_equal({ x: 11, y: 6, width: 21, height: 5 }, span[:bounding_box])
  end

  def test_all_shorthand
    layout = Panes.init(width: 30, height: 10)

    commands = layout.build(id: 'root', width: Panes::Sizing.grow, height: Panes::Sizing.grow) do
      ui(id: 'full', width: Panes::Sizing.grow, height: Panes::Sizing.grow) do
        grid columns: '5 5', rows: '2 2' do
          area :all_area, row: :all, col: :all do
            text 'Cover'
          end
        end
      end
    end

    area = find_command(commands, :all_area, :rectangle)
    assert_equal({ x: 0, y: 0, width: 10, height: 4 }, area[:bounding_box])
  end

  def test_nested_grid_coordinates
    layout = Panes.init(width: 60, height: 20)

    commands = layout.build(id: 'root', width: Panes::Sizing.grow, height: Panes::Sizing.grow) do
      ui(id: 'outer', width: Panes::Sizing.grow, height: Panes::Sizing.grow) do
        grid columns: '20 20', rows: '10 10' do
          area :content, row: 2, col: 2 do
            grid columns: '1fr 1fr', rows: '5 5' do
              area :left, row: 1..2, col: 1 do
                text 'Left'
              end

              area :right, row: 1..2, col: 2 do
                text 'Right'
              end
            end
          end
        end
      end
    end

    content = find_command(commands, :content, :rectangle)
    left = find_command(commands, :left, :rectangle)
    right = find_command(commands, :right, :rectangle)

    assert_equal({ x: 20, y: 10, width: 20, height: 10 }, content[:bounding_box])
    assert_equal({ x: 20, y: 10, width: 10, height: 10 }, left[:bounding_box])
    assert_equal({ x: 30, y: 10, width: 10, height: 10 }, right[:bounding_box])
  end

  def test_invalid_track_token_raises
    layout = Panes.init(width: 20, height: 20)

    assert_raise(ArgumentError) do
      layout.build(id: 'root', width: Panes::Sizing.grow, height: Panes::Sizing.grow) do
        ui(width: Panes::Sizing.grow, height: Panes::Sizing.grow) do
          grid columns: 'foo', rows: '1' do
            area :broken, row: 1, col: 1
          end
        end
      end
    end
  end

  def test_out_of_range_indices_raise
    layout = Panes.init(width: 20, height: 20)

    assert_raise(ArgumentError) do
      layout.build(id: 'root', width: Panes::Sizing.grow, height: Panes::Sizing.grow) do
        ui(width: Panes::Sizing.grow, height: Panes::Sizing.grow) do
          grid columns: '5 5', rows: '5 5' do
            area :invalid, row: 3, col: 1
          end
        end
      end
    end
  end

  def test_empty_track_definition_raises
    layout = Panes.init(width: 20, height: 20)

    assert_raise(ArgumentError) do
      layout.build(id: 'root', width: Panes::Sizing.grow, height: Panes::Sizing.grow) do
        ui(width: Panes::Sizing.grow, height: Panes::Sizing.grow) do
          grid columns: '', rows: '1' do
            area :invalid, row: 1, col: 1
          end
        end
      end
    end
  end

  def test_area_cannot_define_explicit_dimensions
    layout = Panes.init(width: 20, height: 20)

    assert_raise(ArgumentError) do
      layout.build(id: 'root', width: Panes::Sizing.grow, height: Panes::Sizing.grow) do
        ui(width: Panes::Sizing.grow, height: Panes::Sizing.grow) do
          grid columns: '5', rows: '5' do
            area :invalid, row: 1, col: 1, width: 1 do
              text 'bad'
            end
          end
        end
      end
    end
  end

  def test_grid_rejects_non_area_children
    layout = Panes.init(width: 20, height: 20)

    assert_raise(ArgumentError) do
      layout.build(id: 'root', width: Panes::Sizing.grow, height: Panes::Sizing.grow) do
        ui(width: Panes::Sizing.grow, height: Panes::Sizing.grow) do
          grid columns: '5', rows: '5' do
            area :only, row: 1, col: 1
          end

          text 'outside'
        end
      end
    end
  end

  def test_grid_requires_positive_inner_dimensions
    layout = Panes.init(width: 10, height: 10)

    assert_raise(ArgumentError) do
      layout.build(id: 'root', width: Panes::Sizing.grow, height: Panes::Sizing.grow) do
        ui(width: Panes::Sizing.fixed(4), height: Panes::Sizing.fixed(4), padding: [3]) do
          grid columns: '1', rows: '1' do
            area :small, row: 1, col: 1
          end
        end
      end
    end
  end

  private

  def find_command(commands, id, type)
    commands.find { |cmd| cmd[:id] == id && cmd[:type] == type }
  end
end

MTest::Unit.new.run
