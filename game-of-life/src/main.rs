use rand::Rng;
use std::thread::sleep;
use std::time::Duration;
use termion::cursor::{Goto, Hide};
use termion::terminal_size;

const REAL: char = '󰝤';
const FAKE: char = ' ';

fn main() {
    let (mut x, mut y) = get_dimensions();
    let mut map: Vec<Vec<char>> = create_map(x, y);

    map = gen_seed(map);

    let mut i: u32 = 0;
    loop {
        sleep(Duration::from_millis(1));
        (x, y) = get_dimensions();
        map = resize_map(map, x, y);

        if i % 200 == 0 {
            map = calculate(map, x, y);
        }

        print!("{}{}", Hide, Goto(1, 1));
        render(&map);
        i += 1;
    }
}

fn render(map: &Vec<Vec<char>>) {
    for row in map {
        for pixel in row {
            print!("{}", pixel);
        }
    }
}

fn resize_map(map: Vec<Vec<char>>, x: f32, y: f32) -> Vec<Vec<char>> {
    let mut new_map: Vec<Vec<char>> = create_map(x, y);
    if new_map.len() < map.len() || new_map[0].len() < map[0].len() {
        for l in 0..new_map.len() {
            for p in 0..new_map[l].len() {
                new_map[l][p] = map[l][p];
            }
        }
    } else {
        for l in 0..map.len() {
            for p in 0..map[l].len() {
                new_map[l][p] = map[l][p];
            }
        }
    }

    new_map
}

fn get_dimensions() -> (f32, f32) {
    let (f, r) = terminal_size().unwrap();
    let (x, y) = (f as f32, r as f32);
    (x, y)
}

fn create_map(x: f32, y: f32) -> Vec<Vec<char>> {
    let map: Vec<Vec<char>> = vec![vec![FAKE; x as usize]; y as usize];
    map
}

fn gen_seed(mut map: Vec<Vec<char>>) -> Vec<Vec<char>> {
    let mut rng = rand::thread_rng();
    for l in 0..map.len() {
        for p in 0..map[l].len() {
            let number: u8 = rng.gen();
            if number % 10 == 0 {
                map[l][p] = REAL;
            }
        }
    }
    map
}
fn calculate(mut map: Vec<Vec<char>>, x: f32, y: f32) -> Vec<Vec<char>> {
    for l in 0..map.len() {
        for p in 0..map[l].len() {
            if map[l][p] == REAL {
                if count_neighbours(&map, l, p, x, y) <= 2 {
                    map[l][p] = FAKE;
                }
                if count_neighbours(&map, l, p, x, y) == 2
                    || count_neighbours(&map, l, p, x, y) == 3
                {
                    map[l][p] = REAL;
                }

                if count_neighbours(&map, l, p, x, y) > 3 {
                    map[l][p] = FAKE;
                }
            }

            if map[l][p] == FAKE {
                if count_neighbours(&map, l, p, x, y) == 3 {
                    map[l][p] = REAL;
                }
            }
        }
    }
    map
}

fn count_neighbours(map: &Vec<Vec<char>>, l: usize, p: usize, x: f32, y: f32) -> u32 {
    let mut count = 0;
    if p != 0 {
        if map[l][p - 1] == REAL {
            count += 1;
        }
    }
    if p != (x - 1.0) as usize {
        if map[l][p + 1] == REAL {
            count += 1;
        }
    }
    if l != 0 {
        if map[l - 1][p] == REAL {
            count += 1;
        }
    }
    if l != 0 && p != (x - 1.0) as usize {
        if map[l - 1][p + 1] == REAL {
            count += 1;
        }
    }
    if l != 0 && p != 0 {
        if map[l - 1][p - 1] == REAL {
            count += 1;
        }
    }
    if l != (y - 1.0) as usize {
        if map[l + 1][p] == REAL {
            count += 1;
        }
    }
    if l != (y - 1.0) as usize && p != 0 {
        if map[l + 1][p - 1] == REAL {
            count += 1;
        }
    }
    if l != (y - 1.0) as usize && p != (x - 1.0) as usize {
        if map[l + 1][p + 1] == REAL {
            count += 1;
        }
    }
    count
}
