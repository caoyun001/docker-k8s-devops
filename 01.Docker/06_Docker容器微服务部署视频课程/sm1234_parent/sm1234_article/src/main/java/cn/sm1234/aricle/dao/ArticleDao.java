package cn.sm1234.aricle.dao;

import cn.sm1234.aricle.pojo.Article;
import org.springframework.data.jpa.repository.JpaRepository;

/**
 * 文章dao
 */
public interface ArticleDao extends JpaRepository<Article,Integer>{

}
