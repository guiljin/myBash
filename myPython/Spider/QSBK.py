#! /usr/bin/python
# coding: utf-8

import re
import urllib2

__author__ = 'Darren'


class QSBK:
    def __init__(self):
        self.pageIndex = 1
        self.user_agent = 'Mozilla/4.0 (compatible; MSIE 5.5; Windows NT)'
        self.headers = {'User-Agent': self.user_agent}
        # 公司内部必须使用代理
        self.proxy_handler = urllib2.ProxyHandler({"http" : 'http://10.144.1.10:8080'})
        self.stories = []
        self.enable = False

    def getPage(self, pageIndex):
        try:
            opener = urllib2.build_opener(self.proxy_handler)
            urllib2.install_opener(opener)
            url = 'http://www.qiushibaike.com/hot/page/' + str(pageIndex)
            request = urllib2.Request(url, headers=self.headers)
            response = urllib2.urlopen(request)
            pageCode = response.read().decode('utf-8')
            return pageCode
        except urllib2.URLError, e:
            if hasattr(e, "reason"):
                print u"连接糗事百科失败，错误原因", e.reason

    def getPageItems(self, pageIndex):
        pageCode = self.getPage(pageIndex)
        if not pageCode:
            print "页面加载失败..."
            return None
        pattern = re.compile('<div class="author clearfix">.*?<h2>(.*?)</h2>.*?'
                             '<span>(.*?)</span>(.*?)'
                             '<span class="stats-vote"><i class="number">(.*?)</i>', re.S)
        items = re.findall(pattern, pageCode)
        pageStories = []
        for item in items:
            # 去掉带图片的段子
            haveImg = re.search("img", item[2])
            if not haveImg:
                pageStories.append([item[0], item[1].replace("<br/>", "\n"), item[3]])
        return pageStories

    def loadPage(self):
        if self.enable == True:
            if len(self.stories) < 2:
                pageStories = self.getPageItems(self.pageIndex)
                if pageStories:
                    self.stories.append(pageStories)
                    self.pageIndex += 1

    def getOneStory(self, pageStories, page):
        for story in pageStories:
            input = raw_input()
            self.loadPage()
            if input == "Q":
                self.enable = False
                return
            print u"第%d页\t发布人：%s\t赞：%s\n%s" % (page, story[0], story[2], story[1])

    def start(self):
        print u"正在读取糗事百科，按回车查看新段子，Q退出"
        self.enable = True
        self.loadPage()
        nowPage = 0
        while self.enable:
            if len(self.stories) > 0:
                pageStories = self.stories.pop(0)
                nowPage += 1
                self.getOneStory(pageStories, nowPage)


spider = QSBK()
spider.start()
