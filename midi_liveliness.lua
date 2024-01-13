local lib_path = reaper.GetExtState("Lokasenna_GUI", "lib_path_v2")
if not lib_path or lib_path == "" then
    reaper.MB("Couldn't load the Lokasenna_GUI library. Please install 'Lokasenna's GUI library v2 for Lua', available on ReaPack, then run the 'Set Lokasenna_GUI v2 library path.lua' script in your Action List.", "Whoops!", 0)
    return
end
loadfile(lib_path .. "Core.lua")()


GUI.req("Classes/Class - Options.lua")()
GUI.req("Classes/Class - Button.lua")()
GUI.req("Classes/Class - Textbox.lua")()
-- If any of the requested libraries weren't found, abort the script.
if missing_lib then return 0 end


GUI.name = "MIDI liveliness"
GUI.x, GUI.y, GUI.w, GUI.h = 200, 200, 400, 400
GUI.anchor, GUI.corner = "mouse", "C"


local function has_value (tab, val)
  for index, value in ipairs(tab) do
      if value == val then
          return true
      end
  end
  return false
end

  
function get_random_vel(min_vel, max_vel)
  random_vel = math.random(min_vel, max_vel)
  return random_vel
end

function get_altered_pos(startppqposOut, endppqPosOut)
  -- representing altering position of 80% of notes
  altering_these_values = {1, 2, 3, 4, 5, 6, 7, 8, 9, 10}
  random_num = math.random(1, 10)
  if has_value(altering_these_values, random_num) then
    alter_amt = math.random(-10, 10)
    -- if number is even, alter it's start. if odd, alter its end
    if (random_num % 2 == 0) then
      startppqposOut = startppqposOut + alter_amt
    else
      endppqPosOut = endppqPosOut + alter_amt
    end
  end
  return startppqposOut, endppqPosOut
end

      
function make_midi_lively()
  hwnd = reaper.MIDIEditor_GetActive()
  if not hwnd then
    reaper.ShowMessageBox("Please ensure MIDI notes are selected first!", "Error", 0)
  end
  take = reaper.MIDIEditor_GetTake(hwnd)
  retval, notes, ccs, sysex = reaper.MIDI_CountEvts(take)
  min_vel = GUI.Val("min_velocity_tb")
  max_vel = GUI.Val("max_velocity_tb")
  -- Returns number of selection starting from 1 (not the text value)
  alter_pos = GUI.Val("alter_pos_radio")
  for n = 0, notes-1 do
    retval, sel, muted, startppqposOut, endppqPosOut, chan, pitch, vel = reaper.MIDI_GetNote(take, n)
    if sel == true then
        random_vel = get_random_vel(min_vel, max_vel)
        if alter_pos == 1 then
          startppqposOut_altered, endppqPosOut_altered = get_altered_pos(startppqposOut, endppqPosOut)
        else
          startppqposOut_altered = startppqposOut
          endppqPosOut_altered = endppqPosOut
        end
        reaper.MIDI_SetNote(take, n, sel, muted, startppqposOut_altered, endppqPosOut_altered, chan, pitch, random_vel)
    end
  end
end
  

-- GUI section
GUI.New("min_velocity_tb", "Textbox", {
    z = 11,
    x = 64,
    y = 80,
    w = 96,
    h = 20,
    caption = "Min Velocity",
    cap_pos = "top",
    font_a = 3,
    font_b = "monospace",
    color = "txt",
    bg = "wnd_bg",
    shadow = true,
    pad = 4,
    undo_limit = 20
})

GUI.New("max_velocity_tb", "Textbox", {
    z = 11,
    x = 224,
    y = 80,
    w = 96,
    h = 20,
    caption = "Max Velocity",
    cap_pos = "top",
    font_a = 3,
    font_b = "monospace",
    color = "txt",
    bg = "wnd_bg",
    shadow = true,
    pad = 4,
    undo_limit = 20
})

GUI.New("alter_pos_radio", "Radio", {
    z = 11,
    x = 128,
    y = 128,
    w = 96,
    h = 78,
    caption = "Alter position?",
    optarray = {"Yes", "No"},
    dir = "v",
    font_a = 2,
    font_b = 3,
    col_txt = "txt",
    col_fill = "elm_fill",
    bg = "wnd_bg",
    frame = true,
    shadow = true,
    swap = nil,
    opt_size = 20
})

GUI.New("submit_btn", "Button", {
    z = 11,
    x = 140,
    y = 212,
    w = 48,
    h = 24,
    caption = "Submit",
    font = 3,
    col_txt = "txt",
    col_fill = "elm_frame",
    func = make_midi_lively
})

GUI.Init()
GUI.Main()
