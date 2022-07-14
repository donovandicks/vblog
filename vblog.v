module main

import sqlite
import vweb
import time

struct App {
	vweb.Context
pub mut:
	db sqlite.DB
}

fn main() {
	mut app := App{
		// Connects to a SQLite db in-memory
		db: sqlite.connect(':memory:') or { panic(err) }
	}

	// Built in ORM
	sql app.db {
		create table Article
	}

	first_article := Article{
		title: 'Hello, world!'
		text: 'V is great.'
	}

	second_article := Article{
		title: 'Second post'
		text: 'Hm... what should I write about?'
	}

	sql app.db{
		insert first_article into Article
		insert second_article into Article
	}

	vweb.run(app, 8080)
}

// ['/index'] // Handles '/' route'
// pub fn (mut app App) index() vweb.Result {
// 	// variable names must match HTML template names
// 	message := 'Hello, world! -From Vweb'
// 	// '$' indicates compile time actions
// 	// this compiles the HTML template to V
// 	return $vweb.html()
// }

pub fn (app &App) index() vweb.Result {
	articles := app.find_all_articles()
	return $vweb.html()
}

// Route generated with convention, i.e. this can be accessed at '/time'
fn (mut app App) time() vweb.Result {
	return app.text(time.now().format())
}
