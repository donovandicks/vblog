module main

import vweb
import json

struct Article {
	id int [primary; sql; serial]
	title string
	text string
}

pub fn (app &App) find_all_articles() []Article {
	return sql app.db {
		select from Article
	}
}

// Causing compiler error
// pub fn (app &App) find_one_article() ?Article {
// 	return sql app.db {
// 		select from Article limit 1
// 	}
// }

pub fn (app &App) find_articles_in_range(lower int, upper int) []Article {
	return sql app.db {
		select from Article where id >= lower && id <= upper
	}
}

[post]
pub fn (mut app App) new_article(title string, text string) vweb.Result {
	if title == '' || text == '' {
		return app.text('Empty text/title')
	}

	article := Article{
		title: title
		text: text
	}

	println(article)
	sql app.db {
		insert article into Article
	}

	return app.redirect('/')
}

['/new']
pub fn (mut app App) new() vweb.Result {
	return $vweb.html()
}

['/articles'; get]
pub fn (mut app App) articles() vweb.Result {
	articles := app.find_all_articles()
	return app.json(json.encode(articles))
}