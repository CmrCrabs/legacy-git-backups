use glfw::{fail_on_errors, Action, Context, Key, WindowEvent, WindowHint, WindowMode};
use std::ffi::CString;
use std::fs;

fn main() {
    // Source Shader Files
    let vert_source =
        fs::read_to_string("assets/shader.vert").expect("error reading vertex shader");
    let frag_source1 =
        fs::read_to_string("assets/shader.frag").expect("error reading fragment shader");

    let frag_source2 =
        fs::read_to_string("assets/shader2.frag").expect("error reading second fragment shader");

    // Declaring Vertices
    let tri1_vertices: [f32; 9] = [-0.5, 0.5, 0.0, -0.75, -0.5, 0.0, -0.25, -0.5, 0.0];

    let tri2_vertices: [f32; 9] = [0.5, 0.5, 0.0, 0.25, -0.5, 0.0, 0.75, -0.5, 0.0];

    // Initialise Window
    let mut glfw = glfw::init(fail_on_errors!()).unwrap();
    glfw.window_hint(WindowHint::ContextVersion(3, 3));
    glfw.window_hint(WindowHint::OpenGlProfile(glfw::OpenGlProfileHint::Core));

    let (mut window, events) = glfw
        .create_window(800, 600, "Two Triangle", WindowMode::Windowed)
        .expect("Failed to create window");
    window.make_current();
    window.set_all_polling(true);

    gl::load_with(|s| glfw.get_proc_address_raw(s));

    set_viewport();

    link_vert_attributes();

    //  Generate Triangle 1 Data

    let vert_shader1: u32 = gen_shader(&vert_source, gl::VERTEX_SHADER);
    let frag_shader1: u32 = gen_shader(&frag_source1, gl::FRAGMENT_SHADER);
    let shader_program1: u32 = gen_shader_program(vert_shader1, frag_shader1);
    let vao1: u32 = gen_vao(tri1_vertices);

    // Generate Triangle 2 Data
    let vert_shader2: u32 = gen_shader(&vert_source, gl::VERTEX_SHADER);
    let frag_shader2: u32 = gen_shader(&frag_source2, gl::FRAGMENT_SHADER);
    let shader_program2: u32 = gen_shader_program(vert_shader2, frag_shader2);
    let vao2: u32 = gen_vao(tri2_vertices);

    // Render Loop
    while !window.should_close() {
        window.swap_buffers();
        glfw.poll_events();

        clear();
        render_tri(shader_program1, vao1);
        render_tri(shader_program2, vao2);
        // render_quad(shader_program, ebo, vert_arr);

        for (_, event) in glfw::flush_messages(&events) {
            println!("{:?}", event);
            match event {
                WindowEvent::Key(Key::Escape, _, Action::Press, _) => window.set_should_close(true),
                _ => {}
            }
        }
    }
}

fn clear() {
    unsafe {
        gl::ClearColor(1.0, 1.0, 1.0, 1.0);
        gl::Clear(gl::COLOR_BUFFER_BIT);
    }
}

fn set_viewport() {
    unsafe {
        gl::Viewport(0, 0, 800, 600);
    }
}

fn render_tri(shader_program: u32, vert_arr: u32) {
    unsafe {
        gl::UseProgram(shader_program);
        gl::BindVertexArray(vert_arr);
        gl::DrawArrays(gl::TRIANGLES, 0, 3);
    }
}

fn render_quad(shader_program: u32, ebo: u32, vao: u32) {
    unsafe {
        gl::PolygonMode(gl::FRONT_AND_BACK, gl::LINE);

        gl::UseProgram(shader_program);
        gl::BindVertexArray(vao);
        gl::BindBuffer(gl::ELEMENT_ARRAY_BUFFER, ebo);
        gl::DrawElements(gl::TRIANGLES, 6, gl::UNSIGNED_INT, 0 as _);
        gl::BindVertexArray(0);
    }
}

fn gen_shader(source: &String, shader_type: u32) -> u32 {
    unsafe {
        let shader: u32 = gl::CreateShader(shader_type);
        gl::ShaderSource(
            shader,
            1,
            &(source.as_bytes().as_ptr().cast()),
            &(source.len().try_into().unwrap()),
        );
        gl::CompileShader(shader);

        let mut success: i32 = 0;
        let log = CString::from_vec_unchecked(vec![0; 1024]);
        gl::GetShaderiv(shader, gl::COMPILE_STATUS, &mut success);
        if success == 0 {
            gl::GetShaderInfoLog(shader, 1024, std::ptr::null_mut(), log.as_ptr() as _);
            panic!("Could not compile shader, error:\n {:?}", log.to_str());
        }
        shader
    }
}

fn gen_shader_program(vert_shader: u32, frag_shader: u32) -> u32 {
    unsafe {
        let shader_program: u32 = gl::CreateProgram();
        gl::AttachShader(shader_program, vert_shader);
        gl::AttachShader(shader_program, frag_shader);
        gl::LinkProgram(shader_program);

        gl::UseProgram(shader_program);

        gl::DeleteShader(vert_shader);
        gl::DeleteShader(frag_shader);

        let mut success: i32 = 0;
        let log = CString::from_vec_unchecked(vec![0; 1024]);
        gl::GetProgramiv(shader_program, gl::LINK_STATUS, &mut success);
        if success == 0 {
            gl::GetProgramInfoLog(
                shader_program,
                1024,
                std::ptr::null_mut(),
                log.as_ptr() as _,
            );
            panic!("Could not compile program, error:\n {:?}", log.to_str());
        }
        shader_program
    }
}

fn link_vert_attributes() {
    unsafe {
        gl::VertexAttribPointer(0, 3, gl::FLOAT, gl::FALSE, 3 * 4, 0 as _);
        gl::EnableVertexAttribArray(0);
    }
}

fn gen_vao(vertices: [f32; 9]) -> u32 {
    unsafe {
        let mut vert_buf: u32 = 0;
        gl::GenBuffers(1, &mut vert_buf);
        gl::BindBuffer(gl::ARRAY_BUFFER, vert_buf);

        gl::BufferData(
            gl::ARRAY_BUFFER,
            (vertices.len() * 4) as _,
            vertices.as_ptr() as _,
            gl::STATIC_DRAW,
        );

        let mut vert_arr: u32 = 0;
        gl::GenVertexArrays(1, &mut vert_arr);

        gl::BindVertexArray(vert_arr);
        gl::BindBuffer(gl::ARRAY_BUFFER, vert_arr);
        gl::BufferData(
            gl::ARRAY_BUFFER,
            (vertices.len() * 4) as _,
            vertices.as_ptr() as _,
            gl::STATIC_DRAW,
        );

        gl::VertexAttribPointer(0, 3, gl::FLOAT, gl::FALSE, 3 * 4, 0 as _);

        gl::EnableVertexAttribArray(0);
        vert_arr
    }
}

fn gen_ebo(indices: [u32; 6]) -> u32 {
    unsafe {
        let mut ebo: u32 = 0;
        gl::GenBuffers(1, &mut ebo);

        gl::BindBuffer(gl::ELEMENT_ARRAY_BUFFER, ebo);
        gl::BufferData(
            gl::ELEMENT_ARRAY_BUFFER,
            (indices.len() * 4) as _,
            indices.as_ptr() as _,
            gl::STATIC_DRAW,
        );
        ebo
    }
}
