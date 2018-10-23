# svn parallel download according to svn externals
# Author: klarke(miaoyun-klarke.guo@nsn.com)


cmake_minimum_required(VERSION 2.6)

SET(SVN svn)
SET(BEISOP https://beisop60.china.nsn-net.net)

if((svn_dir) AND (IS_ABSOLUTE ${svn_dir}))
    SET(svn_dir ${svn_dir})
elseif(svn_dir)
    SET(svn_dir ${CMAKE_CURRENT_LIST_DIR}/${svn_dir})
else()
    SET(svn_dir ${CMAKE_CURRENT_LIST_DIR})
endif()
MESSAGE(STATUS "use ${svn_dir} as workspace")


if((svn_url) AND (EXISTS ${svn_dir}/.svn))
    execute_process(COMMAND  ${SVN} sw --ignore-externals  ${svn_url}  ${svn_dir} 
        RESULT_VARIABLE svn_sw_result)
    if (svn_sw_result)
        MESSAGE(FATAL_ERROR "fail to check out ${svn_url}")
    endif()
elseif ((svn_url) AND NOT (EXISTS ${svn_dir}/.svn))
    execute_process(COMMAND  ${SVN} co --ignore-externals ${svn_url} ${svn_dir}
        RESULT_VARIABLE svn_co_result)
    if (svn_co_result)
        MESSAGE(FATAL_ERROR "fail to check out ${svn_url}")
    endif()
elseif(EXISTS ${svn_dir}/.svn)
    execute_process(COMMAND ${SVN} info . 
        COMMAND grep "URL:" 
        COMMAND awk "{print $2}"
        WORKING_DIRECTORY  ${svn_dir}
        OUTPUT_VARIABLE svn_url
        OUTPUT_STRIP_TRAILING_WHITESPACE
        )
else()
    MESSAGE(FATAL_ERROR "no svn info found")
endif()
MESSAGE(STATUS "use ${svn_url} to fetch svn")

execute_process(COMMAND ${SVN} pg svn:externals
    COMMAND grep -v "^#"
    COMMAND grep -v "^$"
    WORKING_DIRECTORY  ${svn_dir}
    OUTPUT_VARIABLE externals
    OUTPUT_STRIP_TRAILING_WHITESPACE
    )
STRING(REPLACE "\n" ";" externals  ${externals})

foreach(external ${externals} )
    string(REGEX REPLACE "([^ ]+) *([^ ]+)" "\\2" local_path ${external})
    string(REGEX REPLACE "([^ ]+) *([^ ]+)" "\\1" uri ${external}) 
    string(REPLACE "/" "_" target_name ${local_path})
    if(EXISTS ${svn_dir}/${local_path}/.svn)
        SET(SVN_CMD sw)
    else()
        SET(SVN_CMD co)
    endif()
    add_custom_target(${target_name} ALL
       COMMAND mkdir -p ${local_path}
       COMMAND ${SVN} ${SVN_CMD} ${BEISOP}${uri} ${local_path}
       WORKING_DIRECTORY  ${svn_dir}
        )
endforeach()


unset(svn_dir CACHE)
unset(svn_url CACHE)

